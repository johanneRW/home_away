import uuid
from bottle import default_app, get, post, delete, request, response, run, static_file, template, put 
from utility import utils
from icecream import ic
import bcrypt
import json
import credentials
import time
from utility import variables
from utility import email
import os
import time
import uuid
from werkzeug.utils import secure_filename
from utility import utils
import credentials
from utility import data


@get("/items/page/<page_number>")
def _(page_number):
    try:
        db = utils.db()
        limit = variables.ITEMS_PER_PAGE
        #tjekker hvor mage items der skal vises for at regne ud hvormange sider der skal være i alt
        total_items = data.get_number_of_items(db)

        total_pages = (total_items + limit - 1) // limit
        next_page = int(page_number) + 1
        offset = (int(page_number) - 1) * limit
  
        items = data.get_items_limit_offset(db,limit,offset)
        ic(items)

        is_logged = False
        try:
            utils.validate_user_logged()
            is_logged = True
        except:
            pass
#hvis det er sidste side skal der ikke være  være en "more" button
        is_last_page = int(page_number) >= total_pages

        html = ""
        for item in items:
            html += template("_item", item=item, is_logged=is_logged)
        btn_more = template("__btn_more", page_number=next_page)
        if is_last_page: 
            btn_more = ""
        return f"""
        <template mix-target="#items" mix-bottom>
            {html}
        </template>
        <template mix-target="#more" mix-replace>
            {btn_more}
        </template>
        <template mix-function="addPropertiesToMap">{json.dumps(items)}</template>
        """
    except Exception as ex:
        ic(ex)
        raise
        return "ups..."
    finally:
        if "db" in locals(): db.close()



@get("/items/user")
def _():
    try:
        is_logged = False
        user=""
        try:    
            utils.validate_user_logged()
            user = request.get_cookie("user", secret=credentials.COOKIE_SECRET)
            is_logged = True
        except:
            pass

        if  utils.validate_user_logged():
            user_pk=user['user_pk']
            ic(user_pk)
            #x.disable_cache()
            db = utils.db()
            items =data.get_items_by_user(db, user_pk)
            ic(items)
            return template("items_for_user", items=items,is_logged=is_logged, user=user)
        else: 
           pass
    except Exception as ex:
        raise
        ic(ex)
        return "system under maintainance"         
    finally:
        pass


@post("/items")
def _():
    try:
        user = request.get_cookie("user", secret= credentials.COOKIE_SECRET)

        item_pk=uuid.uuid4().hex
        item_name=utils.validate_item_name()
        item_lat=utils.validate_item_lat()
        item_lon=utils.validate_item_lon()
        item_price_per_night=utils.validate_item_price_per_night()
        item_created_at=int(time.time())
        item_owned_by=user['user_pk']


        ic(item_owned_by)

        
        db = utils.db()
        
        data.create_item(
            db, 
            item_pk, 
            item_name,
            item_lat, 
            item_lon, 
            item_price_per_night, 
            item_created_at, 
            item_owned_by
        )
        
        item = data.get_item(db, item_pk)
        ic(item)

        
        html = template("_item_detail.html", item=item)
       
        return f"""
        <template mix-target="frm_item_{item_pk}" mix-bottom mix-function="updateModalEvents">
        {html}
        </template>
        <template mix-target="#items" mix-bottom mix-function="updateModalEvents">
        {html}
        </template>
        
        """
       
    except Exception as ex:
        ic(ex)
        return f"""
        <template mix-target="#message">
            {ex.args[1]}
        </template>
        """            
    finally:
        if "db" in locals(): db.close()


@put("/items/<item_pk>")
def _(item_pk): 
    try:
        
        item_name = utils.validate_item_name()
        item_lat = utils.validate_item_lat()
        item_lon = utils.validate_item_lon()
        item_price_per_night = utils.validate_item_price_per_night()
     


        db = utils.db()
        data.update_item(db,item_name,item_lat,item_lon,item_price_per_night,item_pk )
        item = data.get_item(db, item_pk)
        
        html = template("_item_detail.html", item=item)
        return f"""
        <template mix-target="frm_item_{item_pk}" mix-replace>
        {html}
        </template>
        """
       
    except Exception as ex:
        ic(ex)
        raise
        return f"""
        <template mix-target="#message">
            {ex.args[1]}
        </template>
        """            
    finally:
        pass


@delete("/items/<item_pk>")
def _(item_pk):
    try:
       
        user = request.get_cookie("user", secret= credentials.COOKIE_SECRET)
        if user:
           
            db = utils.db()
            data.delete_item(db,item_pk)
       
               

        return f"""
        <template mix-target="#item_{item_pk}" mix-replace>
        </template>
        """
       
    except Exception as ex:
        ic(ex)
        return f"""
        <template mix-target="#message">
            {ex.args[1]}
        </template>
        """            
    finally:
        pass


@post("/toggle_item_block/<item_uuid>")
def toggle_item_block(item_uuid):
    try:
       
        current_blocked_status=int(request.forms.get("item_blocked"))
        if current_blocked_status == 0:
            new_blocked_status=1
            button_name="Unblock"
            email_subject = 'Property is blocked'
            email_template = "email_blocked_item"
        else:
            new_blocked_status=0
            button_name="Block"
            email_subject = 'Property is unblocked'
            email_template = "email_ublocked_item"
          

        db = utils.db()
        updated_at = int(time.time())
        data.toggle_block_item(db,new_blocked_status, updated_at, item_uuid)
        
        
        user_info = data.get_user_by_item(db,item_uuid)
        ic(user_info)
        ic(email_subject)
        ic(email_template)
        
        user_first_name=user_info[0]['user_first_name']
        user_email=user_info[0]['user_email']
        ic(user_first_name)
        ic(user_email)


        template_vars = {"user_first_name": user_first_name}
        #email.send_email( user_email, subject, template_name, **template_vars)
        email.send_email(credentials.DEFAULT_EMAIL, email_subject, email_template, **template_vars)

        

        return f"""
            <template mix-target="#item_{item_uuid}" mix-replace>
                <form id="item_{item_uuid}">
            <input type="hidden" name="item_blocked" value="{new_blocked_status}">
            <button id="item_{item_uuid}"
                    mix-data="#item_{item_uuid}"
                    mix-post="/toggle_item_block/{item_uuid}"
                    mix-await="Please wait..."
                    mix-default={button_name}
            >
                {button_name}
            </button>
        </form>
            """
    except Exception as ex:
        return f"<p>Error: {str(ex)}</p>"
    finally:
        if db:
            db.close()
import time
from bottle import delete, get, post, put, request,response, static_file, template
import utils
from icecream import ic
import uuid
import bcrypt 
import variables
import credentials
import os
import time
import uuid
from werkzeug.utils import secure_filename
import utils
import credentials


@put("/items/<item_pk>")
def _(item_pk): 
    try:
        
        item_name = utils.validate_item_name()
        item_lat = utils.validate_item_lat()
        item_lon = utils.validate_item_lon()
        item_price_per_night = utils.validate_item_price_per_night()
        updatet_at=int(time.time())


        db = utils.db()
        db.execute("""
            UPDATE items SET item_name=?, item_lat=?, item_lon=?, item_price_per_night=?, item_updated_at=?
            WHERE item_pk=?
        """, (
            item_name,
            item_lat,
            item_lon,
            item_price_per_night,
            updatet_at,
            item_pk
        ))
        db.commit()

        q = db.execute("""
                SELECT items.*, 
                       group_concat(item_images.image_filename) AS images
                FROM items
                LEFT JOIN item_images ON items.item_pk = item_images.item_pk
                WHERE items.item_pk = ?
                GROUP BY items.item_pk
            """, 
            (item_pk,)
        )
        item = q.fetchone()
        item['images'] = item['images'].split(',')
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
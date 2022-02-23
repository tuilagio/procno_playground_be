# from .crud_item import item
from .crud_user import user
# from .crud_tag import tag, tag_topic
from .crud_topic import topic, topic_question
from .crud_answer import answer
from .crud_question import question
from .crud_small import crud_record, tag, tag_topic, read_text, commentar
# For a new basic set of CRUD operations you could just do

# from .base import CRUDBase
# from app.models.item import Item
# from app.schemas.item import ItemCreate, ItemUpdate

# item = CRUDBase[Item, ItemCreate, ItemUpdate](Item)

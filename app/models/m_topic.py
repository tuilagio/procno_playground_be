# from typing import TYPE_CHECKING, List

from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, ARRAY
# from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
import uuid
from app.db.base_class import Base


# if TYPE_CHECKING:
#     from .item import Item  # noqa: F401

class TopicDB(Base):
    # overwrite the table name, otherwise sqlalchemy will assume "userdb"
    __tablename__ = 'topics'

    id = Column(Integer, index=True)
    uniq_id = Column(UUID(as_uuid=True), primary_key=True, index=True)
    owner_uniq_id = Column(UUID(as_uuid=True), ForeignKey("users.uniq_id"))
    title = Column(String, nullable=False, index=True)
    source_language = Column(String, nullable=False)
    source_level = Column(String, nullable=False)
    wish_correct_languages = Column(ARRAY(String, dimensions=1))
    created_at = Column(DateTime(), nullable=False)
    updated_at = Column(DateTime(), nullable=False)

    def to_string(self):
        return str(
            f"TopicDB:\nid[{str(self.id)}]\n\
            owner_id[{str(self.owner_id)}]\n\
            title[{str(self.title)}]\n\
            source_language[{str(self.source_language)}]\n\
            source_level[{str(self.source_level)}]\n\
            wish_correct_languages[{str(self.wish_correct_languages)}]\n\
            question_id[{str(self.question_id)}]\n\
            created_at[{str(self.created_at)}]\n\
            updated_at[{str(self.updated_at)}]")


class TopicCombiDB(Base):
    # overwrite the table name
    __tablename__ = '__none_topic__'

    # Fake PK and indexed (primary_key=True),
    # cause this table is temporary and doesn't exist in DB
    t_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    t_title = Column(String)
    t_source_language = Column(String)
    t_source_level = Column(String)
    t_wish_correct_languages = Column(ARRAY(String, dimensions=1))
    t_created_at = Column(DateTime(), nullable=False)
    t_updated_at = Column(DateTime(), nullable=False)
    #
    u_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), default=uuid.uuid4)
    u_username = Column(String)
    #
    nbr_answers = Column(Integer)
    #
    tt_tag_uuids = Column(ARRAY(UUID(as_uuid=True), dimensions=1))
    tt_tags = Column(ARRAY(String, dimensions=1))
    #
    q_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), default=uuid.uuid4)
    q_created_at = Column(DateTime(), nullable=False)
    q_updated_at = Column(DateTime(), nullable=False)
    #
    rt_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), default=uuid.uuid4)
    rt_read_text = Column(String)
    rt_created_at = Column(DateTime(), nullable=False)
    rt_updated_at = Column(DateTime(), nullable=False)
    #
    rc_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), default=uuid.uuid4)
    rc_filename = Column(String)
    rc_created_at = Column(DateTime(), nullable=False)
    rc_updated_at = Column(DateTime(), nullable=False)
    #
    c_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), default=uuid.uuid4)
    c_commentar = Column(String)
    c_created_at = Column(DateTime(), nullable=False)
    c_updated_at = Column(DateTime(), nullable=False)

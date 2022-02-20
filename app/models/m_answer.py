# from typing import TYPE_CHECKING

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
# from sqlalchemy.orm import relationship

from app.db.base_class import Base
import uuid
from sqlalchemy.dialects.postgresql import UUID


# if TYPE_CHECKING:
#     from .item import Item  # noqa: F401

class AnswerDB(Base):
    # overwrite the table name
    __tablename__ = 'answers'

    id = Column(Integer, primary_key=True, index=True)
    owner_id = Column(Integer, ForeignKey("users.id"))
    commentar_id = Column(Integer, ForeignKey("commentars.id"))
    record_id = Column(Integer, ForeignKey("records.id"))
    created_at = Column(DateTime(), nullable=False)
    updated_at = Column(DateTime(), nullable=False)

    def to_string(self):
        return str(
            f"TagDB:\nid[{str(self.id)}]\n\
            owner_id[{str(self.owner_id)}]\n\
            commentar_id[{str(self.commentar_id)}]\n\
            record_id[{str(self.record_id)}]\n\
            created_at[{str(self.created_at)}]\n\
            updated_at[{str(self.updated_at)}]")


class AnswerCombiDB(Base):
    # overwrite the table name
    __tablename__ = '__none_answer_combi__'

    # Fake PK and indexed (primary_key=True),
    # cause this table is temporary and doesn't exist in DB
    ans_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    ans_created_at = Column(DateTime(), nullable=False)
    ans_updated_at = Column(DateTime(), nullable=False)
    #
    u_uniq_id: uuid.UUID = Column(UUID(as_uuid=True), default=uuid.uuid4)
    u_username = Column(String)
    u_created_at = Column(DateTime(), nullable=False)
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

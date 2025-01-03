"""xiu gai

Revision ID: f0d10227e8d6
Revises: 7c178af05cdc
Create Date: 2024-12-31 11:04:38.714650

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'f0d10227e8d6'
down_revision: Union[str, None] = '7c178af05cdc'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('role', sa.Column('game_row', sa.Integer(), nullable=True))
    op.drop_column('role', 'game_id')
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('role', sa.Column('game_id', sa.INTEGER(), nullable=False))
    op.drop_column('role', 'game_row')
    # ### end Alembic commands ###

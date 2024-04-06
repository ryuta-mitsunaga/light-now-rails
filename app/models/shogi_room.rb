class ShogiRoom < ApplicationRecord
  belongs_to :user
  has_many :shogi_logs
end

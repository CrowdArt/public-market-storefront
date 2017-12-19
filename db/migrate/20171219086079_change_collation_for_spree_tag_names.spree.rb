# This migration comes from spree (originally 20160511072249)
# This migration is added to circumvent issue #623 and have special characters
# work properly
class ChangeCollationForSpreeTagNames < ActiveRecord::Migration[4.2]
  def up
    execute('ALTER TABLE spree_tags MODIFY name varchar(255) CHARACTER SET utf8 COLLATE utf8_bin;') if ActsAsTaggableOn::Utils.using_mysql?
  end
end

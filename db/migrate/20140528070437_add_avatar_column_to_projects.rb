class AddAvatarColumnToProjects < ActiveRecord::Migration
  def change
  	add_attachment :projects, :avatar
  end
end

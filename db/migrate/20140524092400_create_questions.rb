class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
    t.integer :project_id
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end

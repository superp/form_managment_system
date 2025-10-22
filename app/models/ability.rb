class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    # Users can manage their own forms
    can :manage, Form, user_id: user.id

    # Users can manage their own fields
    can :manage, Field, user_id: user.id

    # Users can manage form fields for their own forms
    can :manage, FormField do |form_field|
      form_field.form.user_id == user.id
    end

    # Users can manage form entries for their own forms
    can :manage, FormEntry do |form_entry|
      form_entry.form.user_id == user.id
    end

    # Users can manage entry values for their own form entries
    can :manage, EntryValue do |entry_value|
      entry_value.form_entry.form.user_id == user.id
    end
  end
end

validates :name, presence: true
p.errors.size
p.valid?
p.errors.objects.first.full_message

2 Validation Helpers
validates :terms_of_service, acceptance: true

validates :terms_of_service, acceptance: { message: 'must be abided' }
validates :terms_of_service, acceptance: { accept: 'yes' }
validates :eula, acceptance: { accept: ['TRUE', 'accepted'] }


2.2 validates_associated

class Library < ApplicationRecord
    validates_associated :books
end

Don't use validates_associated on both ends of your associations. They would call each other in an infinite loop

2.3 confirmation

validates :email, confirmation: true
<%= text_field :person, :email %>
<%= text_field :person, :email_confirmation %>

validates :email, confirmation: { case_sensitive: false }

2.4 comparison
validates :start_date, comparison: { greater_than: :end_date }

2.5 exclusion
validates :subdomain, exclusion: { in: %w(www us ca jp),
    message: "%{value} is reserved." }



    2.6 format
    validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/,
        message: "only allows letters" }
        Alternatively, you can require that the specified attribute does not match the regular expression by using the :without option.

        2.7 inclusion

        validates :size, inclusion: { in: %w(small medium large),
            message: "%{value} is not a valid size" }


2.8 length
validates :name, length: { minimum: 2 }
validates :bio, length: { maximum: 500 }
validates :password, length: { in: 6..20 }
validates :registration_number, length: { is: 6 }

validates :bio, length: { maximum: 1000,
    too_long: "%{count} characters is the maximum allowed" }

    2.9 numericality

    validates :points, numericality: true
    validates :games_played, numericality: { only_integer: true }


2.10 presence
validates :name, :login, :email, presence: true

validates :boolean_field_name, inclusion: [true, false]
validates :boolean_field_name, exclusion: [nil]

2.11 absence
validates :name, :login, 

:email, absence: true

2.12 uniqueness
validates :email, uniqueness: true
alidates :name, uniqueness: { scope: :year,
    message: "should happen once per year" }

    validates :name, uniqueness: { case_sensitive: false }

 2.13 validates_with
 2.14 validates_each
 class Person < ApplicationRecord
    validates_each :name, :surname do |record, attr, value|
      record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
    end
  end
  
  class Person < ApplicationRecord
  validates_each :name, :surname do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
  end
end

Common Validation Options
3.1 :allow_nil
validates :size, inclusion: { in: %w(small medium large),
    message: "%{value} is not a valid size" }, allow_nil: true

    3.2 :allow_blank
    validates :title, length: { is: 5 }, allow_blank: true

    3.3 :message

    validates :name, presence: { message: "must be given please" }
    validates :age, numericality: { message: "%{value} seems wrong" }

3.4 :on
validates :email, uniqueness: true, on: :create
validates :age, numericality: true, on: :update
validates :email, uniqueness: true, on: :account_setup
validates :age, numericality: true, on: :account_setup

4 Strict Validations
validates :name, presence: { strict: true }
validates :token, presence: true, uniqueness: true, strict: TokenGenerationException

5 Conditional Validation
5.1 Using a Symbol with :if and :unless

validates :card_number, presence: true, if: :paid_with_card?

  def paid_with_card?
    payment_type == "card"
  end

  validates :password, confirmation: true,
  unless: Proc.new { |a| a.password.blank? }

    with_options if: :is_admin? do |admin|
        admin.validates :password, length: { minimum: 10 }
        admin.validates :email, presence: true



6 Performing Custom Validations
def validate(record)
    unless record.name.start_with? 'X'
      record.errors.add :name, "Need a name starting with X please!"
    end
  end

  6.2 Custom Methods
  validate :expiration_date_cannot_be_in_the_past,
    :discount_cannot_be_greater_than_total_value

  def expiration_date_cannot_be_in_the_past
    if expiration_date.present? && expiration_date < Date.today
      errors.add(:expiration_date, "can't be in the past")
    end
  end

  def discount_cannot_be_greater_than_total_value
    if discount > total_value
      errors.add(:discount, "can't be greater than total value")
    end
  end


  validate :active_customer, on: :create

  def active_customer
    errors.add(:customer_id, "is not active") unless customer.active?
  end



  7 Working with Validation Errors
  person = Person.new(name: "John Doe")
  person.errors[:name]
  person.errors.where(:name)

  7.4 errors.add
  errors.add :name, :too_plain, message: "is not cool enough"

  8 Displaying Validation Errors in Views

  <% if @article.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@article.errors.count, "error") %> prohibited this article from being saved:</h2>
  
      <ul>
        <% @article.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
  






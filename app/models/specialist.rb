class Specialist < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :address1, :address2, :postalcode, :city, :province, :phone1, :fax, :practise_limitations, :interest, :waittime, :specialization_id, :procedure_ids, :direct_phone, :red_flags, :clinic_ids, :responds_via, :contact_name, :contact_email, :contact_phone, :contact_notes, :referral_criteria, :status_mask, :location_opened, :referral_fax, :referral_phone, :referral_other_details, :urgent_fax, :urgent_phone, :urgent_other_details, :respond_by_fax, :respond_by_phone, :respond_by_mail, :respond_to_patient, :capacities_attributes
  has_paper_trail
  
  belongs_to :specialization

  # specialists have the capacity to perform procedures
  has_many   :capacities
  has_many   :procedures, :through => :capacities
  accepts_nested_attributes_for :capacities, :reject_if => lambda { |a| a[:procedure_id].blank? }, :allow_destroy => true
  
  # specialists attend clinics
  has_many   :attendances
  has_many   :clinics, :through => :attendances
  
  # specialists have "priviliges" at hospitals
  has_many   :privileges
  has_many   :hospitals, :through => :privileges
  
  # specialists are favorited by users of the system
  has_many   :favorites
  has_many   :users, :through => :favorites

  # has many contacts - dates and times they were contacted
  has_many  :contacts

  # dates and times they looked at and changed their own record
  has_many  :views
  has_many  :edits

  validates_presence_of :firstname, :on => :save, :message => "can't be blank"
  validates_presence_of :lastname, :on => :save, :message => "can't be blank"
  validates_presence_of :specialization_id, :on => :save, :message => "can't be blank"

  STATUS_HASH = { 1 => "Accepting new patients", 2 => "Only doing follow up on previous patients", 3 => "Semi-retired", 4 => "Retired"}
  def status
    Specialist::STATUS_HASH[status_mask]
  end
  
  default_scope order('lastname, firstname')
  
  def name
    firstname + ' ' + lastname
  end

  def address
    address = ''
    address += self.address1 || ''
    address += self.address2 || ''
    address
  end
  
  def waittime_or_blank
    self.waittime.blank? ? "n/a" : self.waittime
  end
  
  def waittime?
    self.waittime.blank? ? 'muted' : ''
  end

  def token
    if self.saved_token
      return self.saved_token
    else
      self.saved_token = SecureRandom.hex(16)
      self.save
      return self.saved_token
    end
  end

end

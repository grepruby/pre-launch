class Subscriber < ActiveRecord::Base
  attr_accessible :email, :sub_type
  after_create :add_to_mailchimp
  before_create :set_default
  
  validates :email, :presence => true, :email => true
  validates :sub_type, :presence => true
 
  private
  def add_to_mailchimp
    puts AppConfig[:mailchimp_api_key]
    mailchimp = Hominid::Base.new(:api_key => AppConfig['mailchimp_api_key'])
    list_id = nil
    if self.sub_type.downcase === 'recruiter'
      list_id = mailchimp.find_list_id_by_name(AppConfig['mailchimp_recruiter_list_name'])
    elsif self.sub_type.downcase === 'candidate'
      list_id = mailchimp.find_list_id_by_name(AppConfig['mailchimp_candidate_list_name'])
    end
    return if list_id.blank?
    begin
      mailchimp.subscribe(list_id, self.email, {:FNAME => self.name})
    rescue Exception => e
      Rails.logger.info "Error while adding email to mailchimp \n Exception :: #{e.message}"
    end
  end
  
  def set_default
    self.name = self.email.split("@")[0]
  end
end

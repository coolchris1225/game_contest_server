module Uploadable
  extend ActiveSupport::Concern
  included do
    validates :file_location, presence: true
    validate :check_location
    before_destroy :delete_file
  end 
  
  def delete_file
    File.delete(self.file_location)
  end
  
  def check_location
    if self.file_location && !File.exists?(self.file_location)
      errors.add(:file_location, "is invalid")
    end
  end 
  
  def upload=(uploaded_file)
    if uploaded_file.nil?
      #problem no file
    else
      time_no_spaces = Time.now.to_s.gsub(/\s/, '_')
      file_location = Rails.root.join('code', self.class.to_s.pluralize.downcase, Rails.env, time_no_spaces).to_s + SecureRandom.hex
      #puts("Saving to #{file_location}")
      IO::copy_stream(uploaded_file, file_location)
    end
    self.file_location = file_location
  end
end 
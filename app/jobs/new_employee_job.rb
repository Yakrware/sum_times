class NewEmployeeJob
  include SuckerPunch::Job
  
  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      user = User.find(user_id)
      
      raw, enc = Devise.token_generator.generate(user.class, :reset_password_token)

      user.reset_password_token   = enc
      user.reset_password_sent_at = Time.now.utc
      user.save(:validate => false)
      
      EmployeeMailer.created(user, raw).deliver
    end
  end
end

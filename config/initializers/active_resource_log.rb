ActiveSupport::Notifications.subscribe('request.active_resource')  do |name, start, finish, id, payload|
  pp payload
end if Rails.env.development?

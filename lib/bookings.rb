class Booking
    attr_reader :id, :space_id, :host_id, :user_id, :approval

    def initialize(id, space_id, host_id, user_id, approval)
        @id = id
        @space_id = space_id
        @host_id = host_id
        @user_id = user_id
        @approval = approval
    end 

    def self.approve(booking_id:)
        DatabaseConnection.query("UPDATE bookings SET approval = true WHERE booking_id = #{booking_id}")
        return true
    end 
  
    def self.check_bookings(user_id:)
        result = DatabaseConnection.query("SELECT * FROM bookings WHERE user_id = #{user_id}")
        result.map do |booking|
            Booking.new(booking['id'], booking['space_id'], booking['host_id'], booking['user_id'], booking['approval'])
        end
    end 

    def self.find_booking_id(space_id:)
        result = DatabaseConnection.query("SELECT * FROM bookings WHERE space_id = #{space_id}")
        return result[0]['booking_id']
    end 
end 
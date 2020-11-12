require_relative 'user'
require_relative 'spaces'
class Booking
    attr_reader :booking_id, :space_id, :host_id, :user_id, :approval

    def initialize(booking_id, space_id, host_id, user_id, approval)
        @booking_id = booking_id
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
        bookings = []
        result.each do |booking|
          if booking['approval'] == "t"
            bookings << Booking.new(booking['booking_id'], booking['space_id'], booking['host_id'], booking['user_id'], booking['approval'])
          end
        end
        return bookings
    end

    def self.find_booking_id(space_id:)
        result = DatabaseConnection.query("SELECT * FROM bookings WHERE space_id = #{space_id}")
        return result[0]['booking_id']
    end

    def self.get_space_details
      spaces = []
      bookings = Booking.check_bookings(user_id: User.current_user)
      bookings.each do |booking|
        spaces << Space.find_space(space_id: booking.space_id)
      end
      return spaces
    end

end

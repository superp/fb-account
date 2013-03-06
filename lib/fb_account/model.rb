module FbAccount
  module Model
    extend ActiveSupport::Concern

    included do
      #serialize :friends, Array

      scope :with_name, lambda {|name| where(["#{quoted_table_name}.name LIKE ?", "%#{name}%"]) }
      scope :with_uid, lambda {|uid| where(["#{quoted_table_name}.uid = ?", uid]) }
    end

    module ClassMethods
      def app
        ::FbGraph::Application.new(Config.app_id, :secret => Config.app_secret)
      end

      def auth(redirect_uri = nil)
        ::FbGraph::Auth.new(Config.app_id, Config.app_secret, :redirect_uri => redirect_uri)
      end

      def identify(fb_user)
        _uid = fb_user.identifier.try(:to_s)
        return nil if _uid.blank?

        _fb_user_ = where(:uid => _uid).first || new(:uid => _uid)
        
        _fb_user_.token = fb_user.access_token.access_token

        if _fb_user_.new_record?
          fb_user = fb_user.fetch
          _fb_user_.name = fb_user.name
          _fb_user_.email = fb_user.email
          _fb_user_.photo_url = profile_img(_uid)
          _fb_user_.gender = fb_user.gender || 'male'
          _fb_user_.login = fb_user.username
          _fb_user_.link = fb_user.link
          
          _fb_user_.save!
        else
          _fb_user_.save(:validate => false)
        end
        
        _fb_user_.update_friends if _fb_user_.friends?
        _fb_user_
      end
      
      # square (50x50)
      # small (50 pixels wide, variable height) 
      # normal 
      # large (about 200 pixels wide, variable height)
      #
      def profile_img(uid, type="normal")
        "http://graph.facebook.com/#{uid}/picture?type=#{type}"
      end
    end

    def friends?
      respond_to?(:friends)
    end

    def profile
      @profile ||= ::FbGraph::User.me(self.token).fetch
    end
    
    # check if person join to facebook page
    def is_fun?(group_id=Config.page_id, user_id=self.uid)
      @fun ||= begin
        !::FbGraph::Query.new("SELECT uid FROM page_fan WHERE uid=#{user_id} AND page_id=#{group_id}").fetch(self.token).blank?
      rescue Exception => e
        false
      end
    end
    
    # get person friends
    def friend_data(fid)
      ::FbGraph::Query.new("SELECT sex, name FROM user WHERE uid=#{fid}").fetch(self.token).first || {}
    end
    
    def friends_for_search
      self.friends.select{|f| f['gender'] == 'male'}.map{|f| f.delete_if{|k,v| k == 'gender'}}.inspect.gsub(/\=\>/, ':')
    end
    
    def img(type="normal")
      self.class.profile_img(self.uid, type)
    end
    
    def profile_link
      "http://www.facebook.com/profile.php?id=#{self.uid}"
    end
    
    # update person friends list 1 time by day
    def update_friends
      if self.friends_last_updated_at.nil? || ((self.friends_last_updated_at + 1.day) < DateTime.now)
        self.friends = profile.friends(:fields => 'gender,name').map{|f| {"label" => f.name, "value" => f.identifier, "gender" => f.gender}}
        self.friends_last_updated_at = DateTime.now
        save(:validate => false)
      end
    end
    
    # Facebook feed
    # options are:
    #    :message => 'Updating via FbGraph',
    #    :picture => 'https://graph.facebook.com/matake/picture',
    #    :link => 'http://github.com/nov/fb_graph',
    #    :name => 'FbGraph',
    #    :description => 'A Ruby wrapper for Facebook Graph API'
    #    
    def publish(options = {})
      begin
        profile.feed!(options)
        return true
      rescue Exception => e
        Rails.logger.info "ERROR publish to facebook by person: #{self.id}, uid: #{self.uid}. Message: #{e.message}"
        return nil
      end
    end
  end
end
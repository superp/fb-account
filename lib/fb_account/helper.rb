module FbAccount
  module Helper
    extend ActiveSupport::Concern

    included do
      helper_method :current_account, :account_signed_in?, :signed_request
      after_filter :set_access_control_headers
    end

    module ClassMethods
    end

    protected
        
    def account_signed_in?
      !!current_account
    end
    
    def current_account=(new_account)
      session[:account_id] = new_account ? new_account.id : nil
      @current_account = new_account || false
    end
    
    def current_account
       @current_account ||= account_login_from_session unless @current_account == false
    end
    
    def account_login_from_session
      auth = Account.auth.from_signed_request(signed_request) if signed_request
      if auth && auth.authorized?
        # save current account in session
        session[:account_id] ||= Account.find_by_uid(auth.user.identifier.try(:to_s)).try(:id)
      end
      
      self.current_account = Account.find_by_id(session[:account_id]) if session[:account_id]
    end
    
    def set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = '*'
      headers["P3P"] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"' if request.user_agent.include?('MSIE')
    end
    
    def signed_request
      params[:signed_request]
    end
  end
end
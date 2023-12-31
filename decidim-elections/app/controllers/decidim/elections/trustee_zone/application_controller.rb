# frozen_string_literal: true

module Decidim
  module Elections
    module TrusteeZone
      # This controller is the abstract class from which all trustee_zone
      # controllers in their public engines should inherit from.

      class ApplicationController < ::Decidim::ApplicationController
        include Decidim::UserProfile
        include Decidim::Elections::ContentSecurityPolicy

        helper_method :trustee

        before_action :ensure_configured_bulletin_board!

        register_permissions(::Decidim::Elections::TrusteeZone::ApplicationController,
                             ::Decidim::Elections::Permissions,
                             ::Decidim::Admin::Permissions,
                             ::Decidim::Permissions)

        private

        def ensure_configured_bulletin_board!
          return if Decidim::Elections.bulletin_board.configured?

          announcement = {
            title: "<strong>#{t("no_bulletin_board.title", scope: "decidim.elections.trustee_zone")}</strong>",
            body: t("no_bulletin_board.body", scope: "decidim.elections.trustee_zone")
          }
          render html: cell("decidim/announcement", announcement, callout_class: "alert"), layout: true
        end

        def trustee
          @trustee ||= Decidim::Elections::Trustee.for(current_user)
        end

        def permission_scope
          :trustee_zone
        end

        def permission_class_chain
          ::Decidim.permissions_registry.chain_for(::Decidim::Elections::TrusteeZone::ApplicationController)
        end
      end
    end
  end
end

# Publishes all unpublished exercises and solutions

module Publishables
  module Publish
    class All

      lev_routine

      protected

      def exec
        publishables = Publication.where(published_at: nil).to_a
        Rails.logger.info "Publishing #{publishables.length} objects"

        publishables.each do |p|
          p.publish
          p.save!
        end
      end
    end
  end
end

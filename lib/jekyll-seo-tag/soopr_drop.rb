# frozen_string_literal: true

module Jekyll
  class SeoTag
    # A drop representing soopr and soopr's publish token
    # The publish key will be pulled from:
    #
    # 1. The `soopr` key if it's a string
    # 2. The `soopr.publish_token`  if it's a hash
    # 3. The `soopr.publish_key`  if it's a hash
    class SooprDrop < Jekyll::Drops::Drop

      # Initialize a new SooprDrop
      #
      # page - The page hash (e.g., Page#to_liquid)
      # context - the Liquid::Context
      def initialize(page: nil, site: nil)
        raise ArgumentError unless page && site

        @mutations = {}
        @page = page
        @site = site
      end

      def publish_token
        soopr_hash["publish_token"] || soopr_hash["publish_key"] 
      end
      alias_method :to_s, :publish_token

      private

      attr_reader :page
      attr_reader :site


      def soopr_hash
        @soopr_hash ||= begin
          return {} unless site["soopr"].is_a?(Hash)

          soopr_hash = site["soopr"]
          soopr_hash.is_a?(Hash) ? soopr_hash : {}
        end
      end

      # Since author_hash is aliased to fallback_data, any values in the hash
      # will be exposed via the drop, allowing support for arbitrary metadata
      alias_method :fallback_data, :soopr_hash
    end

    def filters
      @filters ||= Jekyll::SeoTag::Filters.new(context)
    end
  end
end
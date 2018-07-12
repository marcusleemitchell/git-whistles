module Git
  module Whistles
    class Trello
      attr_reader :developer_public_key, :member_token

      def initialize
        get_config
      end

      def get_client(opts = {})
        options = {
          developer_public_key: @developer_public_key,
          member_token: @member_token
        }

        options.merge!(opts)

        Trello.configure do |config|
          config.developer_public_key = options[:developer_public_key]
          config.member_token = options[:member_token]
        end
      end

      def get_config
        @developer_public_key = `git config trello.developer_public_key`.strip
        if developer_public_key.empty?
          puts Term::ANSIColor.yellow %Q{
            Your branch appears to have a issue ID,
            but I don't know your Trello member token!
            Please set it with:
            $ git config [--global] jira.username <username>
          }
          raise "Aborting."
        end

        @password = `git config jira.password`.strip
        if password.empty?
          puts Term::ANSIColor.yellow %Q{
            Your branch appears to have a issue ID,
            but I don't know your JIRA password!
            Please set it with:
            $ git config [--global] jira.password <password>
          }
          raise "Aborting."
        end

        @site = `git config jira.site`.strip
        if site.empty?
          puts Term::ANSIColor.yellow %Q{
            Your branch appears to have a issue ID,
            but I don't know your JIRA site!
            Please set it with:
            $ git config [--global] jira.site <https://mydomain.atlassian.net>
          }
          raise "Aborting."
        end
      end
    end
  end
end

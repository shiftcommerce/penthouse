#
# The OctopusSchemaTenant class relies upon Octopus [1], it uses the master
# database and simply switches the schema search path to allow for isolated
# data, but low overheads in terms of costs. Note: this means tenants will be
# sharing a single Postgres instance and therefore performance is shared.
#
# [1]: (https://github.com/thiagopradi/octopus)
#

require_relative './schema_tenant'
require 'octopus'

module Penthouse
  module Tenants
    class OctopusSchemaTenant < SchemaTenant

      # ensures we're on the master Octopus shard, just updates the schema name
      # with the tenant name
      # @param block [Block] The code to execute within the schema
      # @yield [SchemaTenant] The current tenant instance
      def call(&block)
        Octopus.using(:master) do
          super
        end
      end

      # creates the tenant schema within the master shard
      # @see Penthouse::Tenants::SchemaTenant#create
      def create(*)
        call { super }
      end

      # drops the tenant schema within the master shard
      # @see Penthouse::Tenants::SchemaTenant#delete
      def delete(*)
        call { super }
      end

      # returns whether or not the schema exists
      # @see Penthouse::Tenants::SchemaTenant#exists?
      def exists?(*)
        call { super }
      end
    end
  end
end

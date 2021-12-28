# frozen_string_literal: true

module GitFame
  class Diff < Base
    include Enumerable

    attribute :commit, Types::Any
    delegate :tree, to: :commit
    delegate :repo, to: :tree

    # @yield [Hash]
    #
    # @return [void]
    def each(&block)
      tree.walk(:preorder).each do |root, entry|
        case entry
        in { type: :blob, name: file, oid: }
          Rugged::Blame.new(repo, root + file, newest_commit: commit).each(&block)
        in { type: type, name: file }
          say("Ignore type [%s] in for %s for %p", type, root + file, commit)
        end
      end
    end
  end
end

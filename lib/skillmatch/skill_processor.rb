require 'amatch'

module Skillmatch
  module SkillProcessor
    include Amatch

    def match_skill_for(term, connections, threshold=0.8)
      return connections if term.nil? || '' == term
      matcher = JaroWinkler.new(term)
      connections.select do |cnn|
        next unless cnn["skills"]
        cnn["skills"]["all"].any? do |skill|
          cnn["similarity"] = matcher.match(skill["skill"]["name"])
          cnn["similarity"] > threshold
        end
      end.sort do |a, b|
        a["similarity"] <=> b["similarity"]
      end.reverse
    end
  end
end

require 'test_helper'
require 'skillmatch/skill_processor'

module Skillmatch
  class SkillProcessorTest < Test::Unit::TestCase
    include Skillmatch::SkillProcessor

    test "processes a list of connections for a skill" do
      actual = match_skill_for("Ruby", [
        ruby_skilled_connection, ruby_rails_skilled_connection
      ])

      assert has_only_ruby_connections?(actual)
    end

    test "orders results by similarity" do
      actual = match_skill_for("Ruby", [
        ruby_rails_skilled_connection, ruby_skilled_connection
      ])

      assert has_only_ruby_connections?(actual)
    end

    test "does not return connections under skill match threshold" do
      actual = match_skill_for("Ruby", [
        ruby_skilled_connection,
        non_ruby_skilled_connection,
        ruby_rails_skilled_connection
      ])

      assert has_only_ruby_connections?(actual)
    end

    test "skips over connections that have no skills" do
      actual = match_skill_for("Ruby", [
        ruby_skilled_connection,
        unskilled_connection,
        ruby_rails_skilled_connection
      ])

      assert has_only_ruby_connections?(actual)
    end

    private
      def has_only_ruby_connections?(results)
        return false unless 2 == results.length
        assert_equal "Jim",    results[0]["first_name"]
        assert_equal "Connor", results[1]["first_name"]
      end

      def unskilled_connection
        {"first_name"=>"George", "id"=>"znbD", "last_name"=>"Jetson"}
      end

      def ruby_skilled_connection
        {"first_name"=>"Jim",
         "id"=>"oRtv",
         "last_name"=>"Beam",
         "skills"=>
          {"total"=>4,
           "all"=>
            [{"id"=>1, "skill"=>{"name"=>"Ruby"}},
             {"id"=>2, "skill"=>{"name"=>"Git"}},
             {"id"=>3, "skill"=>{"name"=>"Java"}},
             {"id"=>5, "skill"=>{"name"=>"Bowling"}}
            ]
          }
        }
      end

      def ruby_rails_skilled_connection
        {"first_name"=>"Connor",
         "id"=>"fdoQ",
         "last_name"=>"McCleod",
         "skills"=>
          {"total"=>3,
           "all"=>
            [{"id"=>1, "skill"=>{"name"=>"Git"}},
             {"id"=>3, "skill"=>{"name"=>"Swordfighting"}},
             {"id"=>5, "skill"=>{"name"=>"Ruby on Rails"}}
            ]
          }
        }
      end

      def non_ruby_skilled_connection
        {"first_name"=>"Bart",
         "id"=>"tlWb",
         "last_name"=>"Simpson",
         "skills"=>
          {"total"=>2,
           "all"=>
            [{"id"=>1, "skill"=>{"name"=>"Sarcasm"}},
             {"id"=>5, "skill"=>{"name"=>"Skateboarding"}}
            ]
          }
        }
      end
  end
end

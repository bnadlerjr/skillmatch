require "rake/testtask"
require "rdoc/task"
require "reek/rake/task"
require "roodi"
require "roodi_task"
require "flay_task"
require "flog_task"

DEFAULT_TASKS    = %w[test flog flay]
EXTRA_RDOC_FILES = ['README.rdoc']
LIB_FILES        = Dir["lib/**/*.rb"]
MAIN_RDOC        = 'README.rdoc'
TEST_FILES       = Dir["test/**/*_test.rb"]
TITLE            = 'skillmatch'

desc "Default tasks: #{DEFAULT_TASKS.join(', ')}"
task :default => DEFAULT_TASKS

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = TEST_FILES
end

RDoc::Task.new do |t|
  t.main = MAIN_RDOC
  t.rdoc_dir = 'doc'
  t.rdoc_files.include(EXTRA_RDOC_FILES, LIB_FILES)
  t.options << '-q'
  t.title = TITLE
end

RoodiTask.new do |t|
  t.patterns = %w[lib/**/*.rb]
end

FlayTask.new do |t|
  t.dirs = %w[lib]
end

FlogTask.new do |t|
  t.dirs = %w[lib]
end

Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
end

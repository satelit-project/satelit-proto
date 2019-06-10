# frozen_string_literal: true

# Configuration of every project that uses protos
module Project
  # Path to the root protos directory
  # @return [String]
  def import_path
    @import_path
  end

  # Protos that is required by the project
  # @return [Array<String>]
  def protos; end

  def protos_for_pattern(pattern)
    protos = []
    Dir.glob(pattern, base: import_path) do |file|
      protos << (import_path + file).to_s
    end

    protos
  end
end

def config_for_project(project, import_path)
  case project
  when ProjectImport.name
    ProjectImport.new(import_path)

  when ProjectScraper.name
    ProjectScraper.new(import_path)

  else
    raise "Project #{project} is not supported"
  end
end

# Configuration for 'satelit-import' project
class ProjectImport
  include Project

  def self.name
    'satelit-import'
  end

  def initialize(import_path)
    @import_path = import_path
  end

  def protos
    result = protos_for_pattern('scraper/**/*.proto')
    result << protos_for_pattern('scheduler/**/*.proto')
    result
  end
end

# Configuration for 'satelit-scraper' project
class ProjectScraper
  include Project

  def self.name
    'satelit-scraper'
  end

  def initialize(import_path)
    @import_path = import_path
  end

  def protos
    protos_for_pattern('scraper/**/*.proto')
  end
end

# Configuration for `satelit-scheduler` project
class ProjectScheduler
  include Project

  def self.name
    'satelit-scheduler'
  end

  def initialize(import_path)
    @import_path = import_path
  end

  def protos
    protos_for_pattern('scheduler/**/*.proto')
  end
end

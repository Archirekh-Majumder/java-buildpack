
require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'java_buildpack/logging/logger_factory'

module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling zero-touch JRebel support.
    class CodeInsightAgent < JavaBuildpack::Component::VersionedDependencyComponent

      def initialize(context)
        super(context)
        @component_name = 'CodeInsight-Java'
        @logger = JavaBuildpack::Logging::LoggerFactory.instance.get_logger CodeInsightAgent
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Code Insight path: #{agent_jar}" }
        print "Code Insight path: #{agent_jar}"
        download_zip(false, @droplet.sandbox)
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        @logger.debug { "Code Insight path: #{agent_jar}" }
        @droplet
          .java_opts
          .add_javaagent(agent_jar)
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        codeinsight_configured?(@application.root + 'META-INF/MANIFEST.MF')
      end

      private

      def codeinsight_configured?(root_path)
        (root_path).exist?
      end

      def agent_jar
        string1 = @droplet.sandbox + "CodeInsight-Java.jar="
        string2 = @droplet.sandbox + "CodeInsight-Java.xml"
        string3 = string1 + string2
        @logger.debug { "Code Insight path: #{string3}" }
        return string3
      end

    end

  end
end

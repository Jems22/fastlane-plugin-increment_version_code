require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    class IncrementVersionCodeAction < Action
      def self.run(params)
        app_folder_name ||= params[:app_folder_name]
        UI.message("The get_version_code plugin is looking inside your project folder (#{app_folder_name})!")

        version_code = "0"
        new_version_code = "0"

        temp_file = Tempfile.new('fastlaneIncrementVersionCode')
        Dir.glob("../**/#{app_folder_name}/build.gradle") do |path|
            begin
                  File.open(path, 'r') do |file|
                    file.each_line do |line|
                        if line.include? "versionCode"
                           versionComponents = line.strip.split(' ')
                           version_code = versionComponents[1].tr("\"","")
                           new_version_code = version_code.to_i + 1
                           line.replace line.sub(version_code, new_version_code.to_s)
                           temp_file.puts line
                       else
                           temp_file.puts line
                       end
                    end
                  end
                  temp_file.close
                  FileUtils.mv(temp_file.path, path)
                ensure
                  temp_file.close
                  temp_file.unlink
            end
        end

        if version_code == "0" || new_version_code == "1"
            UI.user_error!("Impossible to find the version code in the current project folder #{app_folder_name} 😭")
        else
            # Store the version name in the shared hash
            Actions.lane_context["VERSION_CODE"]=version_code
            UI.success("☝️ Version code has been changed from #{version_code} to #{new_version_code}")
        end
      end

      def self.description
        "Increment the version code of your android project."
      end

      def self.authors
        ["Jérémy TOUDIC"]
      end

      def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :app_folder_name,
                                    env_name: "INCREMENTVERSIONCODE_APP_FOLDER_NAME",
                                 description: "The name of the application source folder in the Android project (default: app)",
                                    optional: true,
                                        type: String,
                               default_value:"app")
          ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end

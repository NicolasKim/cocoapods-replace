require 'cocoapods-replace/command'


module CococapodsReplacement
  Pod::HooksManager.register 'cocoapods-replace', :post_install do | installer |
    # Pod::UserInterface.info "Start remove 'NSLog' ..."
    # Pod::UserInterface.info "SandBox #{installer.sandbox.root}"
    dir = installer.sandbox.root.join("Target Support Files")
    Pod::UserInterface.title "Start remove 'NSLog' by 'cocoapods-replace' ..."
    # Pod::UserInterface.info "Target Support Files #{dir}"
    #installer.podfile.to_hash["replacement"]
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        prefix_file_name = dir.join("#{target.name}/#{target.name}-prefix.pch")
        if File.exist? prefix_file_name
          Pod::UserInterface.message "[#{target.name}-#{config.name}]"
          # Pod::UserInterface.info "Set GCC_PRECOMPILE_PREFIX_HEADER true"
          config.build_settings['GCC_PRECOMPILE_PREFIX_HEADER'] = 'YES'
          # Pod::UserInterface.info "Fix #{target.name} at #{prefix_file_name}"
          file = File.open(prefix_file_name, "a+")
          ruby_code = <<-CODE
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif
          CODE
          file.puts ruby_code unless file.read.include? ruby_code
          file.close
          # Pod::UserInterface.info "=============================[#{target.name}]============================="
        end
      end
    end
    Pod::UserInterface.title "End remove 'NSLog' by 'cocoapods-replace' ..."
  end
end
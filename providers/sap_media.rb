action :extract do
  #######################
  ## Collect Variables ##
  #######################

  # Where to put SAPCAR
  sapcar_dir = node['platform_family'] == 'windows' ? ENV['WINDIR'] : '/usr/local/bin/'
  # The file name of the sapcar executable
  sapcar_ex = new_resource.sapcar.split('/')[-1]

  # The full URL to the sar package
  sar_url = new_resource.remote_path
  # The file name of the sar package, for friendly logging
  sar_file = sar_url.split('/')[-1]
  # Where to put the extracted contents
  sar_extract_dir = new_resource.extractDir
  # The path to the loac copy of the SAR
  local_sar = "#{Chef::Config[:file_cache_path]}/#{sar_file}"

  ########################
  ##  Download SAPCAR   ##
  ########################

  remote_file "#{sapcar_dir}/#{sapcar_ex}" do
    source new_resource.sapcar
    mode 00755
    action :create_if_missing
  end

  ######################
  ## Download the SAR ##
  ######################
  remote_file local_sar do
    source sar_url
    mode 0755
    action :create_if_missing
  end

  ##########################
  ## Remove this section  ##
  ##########################
#
#    extractDir_array = new_resource.extractDir.split(/[\/\\]/)
#    # A file in the root -1 of the extrat directory vv
#    idxfile = extractDir_array[0..extractDir_array.size-2].join('/')+"/LABELIDX.ASC"
#    # Prepare for search
#    search_path = new_resource.extractDir.tr("/","\\/")
#
#    # Touches the file (idxfile)
#    ruby_block "Touching #{idxfile}" do
#      block do
#        FileUtils.mkdir_p(File.dirname(idxfile))
#        FileUtils.touch(idxfile)
#      end
#    end
#

  ##########################
  ## Extract the package  ##
  ##########################

  # Creates the destination directory
  directory sar_extract_dir do
    recursive true
  end

  # Use SAPCAR to extract the downloaded package to its destination
  execute "Extract media #{sar_file} to #{sar_extract_dir}" do
    command "#{sapcar_ex} -xf #{local_sar} -R #{sar_extract_dir}"
  end

#  Updates the file with the location of the extraction
  # ruby_block "Updating LABELIDX.ASC" do
    # block do
      # File.open(idxfile, 'a') do |file|
        # file.puts new_resource.extractDir
      # end
    # end
    # not_if { ::File.readlines(idxfile).grep(/^#{search_path}$/).any? }
  # end

  #####################
  ## Cleanup the SAR ##
  #####################

  file local_sar do
    action :delete
    backup false
  end
end # end action

class Cluster
    def self.setupLoader(config)
	        
	end
	def self.installPlugin(vagrant, argv ,plugins)
	    plugin_installed = false
		if argv[0] == 'up' 
        
			plugins.each do |plugin|
				unless vagrant.has_plugin?(plugin)
					system "vagrant plugin install #{plugin}"
					plugin_installed = true
				end
			end
			
			if plugin_installed === true
				exec "vagrant #{ARGV.join' '}"    
			end
		end
	end
end
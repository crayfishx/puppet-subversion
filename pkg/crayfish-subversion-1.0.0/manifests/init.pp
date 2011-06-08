# Class: subversion
#
# Manage subversion checkouts
class subversion { 

	package { "subversion":
		ensure		=> latest,
	}

	$svnflags = "--non-interactive"

# Definition: svn::checkout
#
# Check out a subversion repository to a working directory
#
# Parameters:
#   $repopath 			- Path to the repository
#   $workingdir			- Local working directory to checkout to
#   $ensure (optional)		- Set to updated to ensure latest svn update
#   $host (optional)		- Subversion server hostname
#   $method (optional)		- Protocol to use (http,https,svn..etc)
#   $svnuser (optional) 	- Username to connect with
#   $password (optional)	- Password to connect with
#   $revision (optional)	- Revision to check out
#   $trustcert(optional)	- Use --trust-server-cert
#
#
# Sample usage
#	subversion::checkout { "application/trunk": 
#		repopath	=> "/app/trunk",
#		workingdir	=> "/var/src/app",
#		host		=> "subversion.local",
#		method		=> "http",
#		svnuser		=> "application",
#		password	=> "kjhsdfkj",
#		require		=> File["/var/src/app"],
#	}
#	
	define checkout (
			$repopath,
			$workingdir,
			$ensure		= "exists",
			$host		= false,
			$method		= false,
			$svnuser	= false,
			$revision	= "HEAD",
			$password	= false,
			$trustcert	= false
	) { 


		
		$urlmethod = $method ? { 
				false 	=> "",
				default => "$method://"
				}

		$optuser = $svnuser ? { 
				false	=> "",
				default	=> "--username $svnuser",
		}

		$urlhost = $host ? { 
				false	=> "",
				default	=> "$host"
		}

		$optpassword = $password ? { 
				false	=> "",
				default	=> "--password $password"
		}

		$opttrustcert = $trustcert ? { 
				false	=> "",
				default => "--trust-server-cert"
		}




		$svnurl = "${urlmethod}${urlhost}${repopath}"
		Exec { path	=> "/bin:/usr/bin:/usr/local/bin" }
			

		exec { "$svnurl:$workingdir:checkout": 
			cwd	=> $workingdir,
			command	=> "svn checkout $svnflags $optuser $optpassword $opttrustcert -r$revision $svnurl $workingdir",
			creates	=> "$workingdir/.svn",
			require	=> Package["subversion"],
		}


		if ( $ensure == "updated" ) { 
			exec { "$svnurl:$workingdir:update": 
				cwd	=> "$workingdir",
				command => "svn update $svnglags $optuser $optpassword $opttrustcert -r$revision",
				require	=> Package["subversion"],
			}
		}	


	}

	
			
}


			
			

		
			
			
		

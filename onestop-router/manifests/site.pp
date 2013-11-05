# general config options
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/opt/jruby/bin", "/usr/local/rvm/bin" ] }

class install_dependencies {
  exec {
    "update system":
      command => "apt-get update",
      user => 'root';
  }

  exec {
    "install dependencies":
      command => "apt-get install -y libqt4-dev xvfb libxml2-dev libxslt1-dev libssl-dev vim",
      user => 'root';
  }
}

class install_oracle {
  include oracle::server
  include oracle::xe
}

class install_rvm {
  include rvm

  rvm::system_user { root: ; vagrant: ; }
  rvm_system_ruby {
    'jruby':
      ensure      => 'present',
      default_use => true;
  }

  if $rvm_installed == "true" {
    exec {
      "Run JRuby in 1.9 mode":
        command => "echo 'export JRUBY_OPTS=\"--1.9 -J-Xmx1024m\"' >> ~/.bashrc",
        cwd     => "/home/vagrant",
        user    => 'vagrant',
        group   => 'admin';
    }

    exec {
      "Setup rvm for user install":
        command => "rvm user all",
        cwd     => "/home/vagrant",
        user    => "vagrant",
        group   => "admin";
    }

    rvm_gem {
      'bundler':
        name         => 'bundler',
        ruby_version => 'jruby',
        ensure       => latest,
        require      => Rvm_system_ruby['jruby'];
    }

    rvm_gem {
      'puppet':
        ensure  => '3.0.1',
        require => Rvm_system_ruby['jruby'];
    }
  }
}

class bundle_and_setup_database {
  if $rvm_installed == "true" {
    exec {
      "bundle install":
        command => "rvm use jruby --default && jruby -S bundle install",
        cwd => "/vagrant",
        user => 'vagrant',
        group => 'admin';
    }

    exec {
      "setup database":
        command => "rvm use jruby && jruby -S bundle exec rake db:setup",
        cwd => "/vagrant",
        user => 'vagrant',
        group => 'admin';
    }
  }
}

node oraxe {
  # install everything
  include install_dependencies
  include java
  include install_oracle
  include install_rvm
  include bundle_and_setup_database
}

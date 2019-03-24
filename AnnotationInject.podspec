Pod::Spec.new do |s|
  s.name                    = "AnnotationInject"
  s.version                 = "0.4.0"
  s.source                  = { :git => "https://github.com/akane/AnnotationInject.git",
                                :tag => s.version.to_s }

  s.summary                 = "Swift dependency injection with annotations."
  s.description             = "Makes your code safer by using annotations to manage your dependencies. Built with Sourcercy and Swinject."
  s.homepage                = s.source[:git]
  s.license                 = { :type => "MIT", :file => "LICENSE" }
  s.author                  = 'pjechris', 'akane'

  s.ios.deployment_target   = "8.0"
  s.swift_version           = "4.2"
  s.preserve_paths          = 'Scripts', 'Templates'

  s.dependency              'Sourcery', '>= 0.16.0'
  s.dependency              'Swinject'
end

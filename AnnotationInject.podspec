Pod::Spec.new do |s|
  s.name                    = "AnnotationInject"
  s.version                 = "0.6.1"
  s.source                  = { :git => "https://github.com/pjechris/AnnotationInject.git",
                                :tag => s.version.to_s }

  s.summary                 = "Swift dependency injection with annotations."
  s.description             = "Makes your code safer by using annotations to manage your dependencies. Built with Sourcercy and Swinject."
  s.homepage                = s.source[:git]
  s.license                 = { :type => "MIT", :file => "LICENSE" }
  s.author                  = 'pjechris'

  s.ios.deployment_target   = "8.0"
  s.swift_version           = ['4.2', '5.0','5.1', '5.2', '5.3', '5.4' ,'5.5', '5.6', '5.7']
  s.preserve_paths          = 'Sources', 'Scripts', 'Templates'
  s.prepare_command         = './Scripts/generate-annotation-template'

  s.dependency              'Sourcery', '>= 1.0.0'
  s.dependency              'Swinject'
end

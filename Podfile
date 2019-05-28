
platform :ios, '11.0'
workspace 'HelloSensorsAnalytics.xcworkspace'

abstract_target 'abstract_HelloSensorsAnalytics' do
    pod 'SensorsAnalyticsSDK'
    pod 'Masonry'
    pod 'SVProgressHUD'
    #pod 'HFFoundation', :path=>'~/Developer/iOS/HFFoundation'
    #pod 'SensorsDebugger', :path=>'~/Developer/iOS/SensorsDebugger'
    #pod 'LDNetDiagnoService', :git =>  'https://github.com/Lede-Inc/LDNetDiagnoService_IOS.git'
    # pod 'DoraemonKit/Core', '~> 1.1.4', :configurations => ['Debug']

    target :HelloSensorsAnalytics do
        project 'HelloSensorsAnalytics.xcodeproj'
    end

    
    target :MultiStatistics do
        project 'Examples/MultiStatistics/MultiStatistics.xcodeproj'
        pod 'UMCAnalytics'
    end
    
    
    target :BackgroundMode do
    project 'Examples/BackgroundMode/BackgroundMode.xcodeproj'
        pod 'JPush'
    end
    
end


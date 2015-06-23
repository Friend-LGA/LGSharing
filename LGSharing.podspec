Pod::Spec.new do |s|

    s.name = 'LGSharing'
    s.version = '1.0.0'
    s.platform = :ios, '6.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGSharing'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGSharing.git', :tag => s.version }
    s.summary = 'iOS helper for easy sharing with email, message or social networks like facebook, twitter, google+ and vkontakte'

    s.requires_arc = true

    s.source_files = 'LGSharing/*.{h,m}'

    s.subspec 'LGSharingVkontakte' do |ss|
        ss.source_files = 'LGSharing/LGSharingVkontakte/*.{h,m}'
    end

    s.subspec 'LGSharingGooglePlus' do |ss|
        ss.source_files = 'LGSharing/LGSharingGooglePlus/*.{h,m}'
    end

    s.dependency 'VK-ios-sdk', '~> 1.1.7'
    s.dependency 'google-plus-ios-sdk', '~> 1.7.1'

end

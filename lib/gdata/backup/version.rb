module Gdata
  class Backup
    MAJOR    = 0
    MINOR    = 0
    REVISION = 2
    VERSION  = [MAJOR, MINOR, REVISION].map(&:to_s).join('.')
  end
end


# http://stackoverflow.com/questions/4877931/how-to-return-an-empty-activerecord-relation

class ActiveRecord::Base
   def self.none
     where('0=1')
   end
end

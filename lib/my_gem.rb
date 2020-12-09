require 'csv'
require 'json'
module MyGem
  class Converter
    $keys = Array.new
    def self.get_keys(hash, recursiveKey= nil)
      hash.each do |(k,v)|
        if recursiveKey != nil
          k= "#{recursiveKey}.#{k}"
        end
        if v.is_a? Hash
          get_keys(v, k)
        else
          if not $keys.include?(k)
            $keys << k
          end
        end
      end
    end


    def self.jsonToCsv?(input, output)
      json = JSON.parse(File.open(input).read)
      json.each do |hash|
        get_keys(hash)
      end
      puts $keys
      CSV.open(output, 'w') do |csv|
        csv << $keys
        json.each do |hash|
          ## on cherche a creer un tableau dans le bon ordre, on va utiliser notre tableau de keys pour ca
          values = Array.new($keys.length())
          index= 0
          $keys.each do |key|
            splittedKeys = key.split(".")
            if splittedKeys.length() == 1 
              value = hash[key]
              if  value
                if  value.is_a?(Array)
                  value = value.join(',') 
                end
                values[index] = value
              end
            else
              finalValue = hash[splittedKeys[0]]
              cpt = false
              splittedKeys.each do |keyBis|
                if cpt == true
                  finalValue = finalValue[keyBis]
                end
                cpt = true
              end
              if finalValue
                if  finalValue.is_a?(Array)
                  finalValue = finalValue.join(',') 
                end
                values[index] = finalValue
              end
            end
            index = index + 1
          end
          csv << values
        end
      end
    end
  end
end
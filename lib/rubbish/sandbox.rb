module Rubbish
  class Sandbox
    def initialize obj = nil
      @guinea_pig = obj || Object.new
    end

    def run_code code
      begin
        rv = @guinea_pig.instance_eval(code)
        { ok: true, value: rv }
      rescue Exception => e
        { ok: false, error: e }
      end
    end
  end
end

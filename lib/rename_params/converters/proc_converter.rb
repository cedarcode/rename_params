module RenameParams
  class ProcConverter
    def initialize(proc)
      @proc = proc
    end

    def convert(value)
      @proc.call(value)
    end
  end
end
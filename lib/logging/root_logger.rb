# $Id$

require 'logging'
require 'logging/logger'

module Logging

  # The root logger exists to ensure that all loggers have a parent and a
  # defined logging level. If a logger is additive, eventually its log
  # events will propogate up to the root logger.
  #
  class RootLogger < Logger

    # undefine the methods that the root logger does not need
    %w(additive additive= parent parent=).each do |m|
      undef_method m.intern
    end

    # call-seq:
    #    RootLogger.new
    #
    # Returns a new root logger instance. This method will be called only
    # once when the +Repository+ singleton instance is created.
    #
    def initialize( )
      unless ::Logging.const_defined? 'MAX_LEVEL_LENGTH'
        ::Logging.define_levels %w(debug info warn error fatal)
      end

      @name = 'root'
      @appenders = []
      @additive = false
      @trace = false
      self.level = 0
    end

    # call-seq:
    #    log <=> other
    #
    # Compares this logger by name to another logger. The normal return codes
    # for +String+ objects apply.
    #
    def <=>( other )
      case other
      when self: 0
      when ::Logging::Logger: -1
      else raise ArgumentError, 'expecting a Logger instance' end
    end

    # call-seq:
    #    level = :all
    #
    # Set the level for the root logger. The functionality of this method is
    # the same as +Logger#level=+, but setting the level to +nil+ for the
    # root logger is not allowed. The level is silently set to :all.
    #
    def level=( level )
      level ||= 0
      super
    end

  end  # class RootLogger
end  # module Logging

# EOF
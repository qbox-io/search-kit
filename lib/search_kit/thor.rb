require 'thor'

class Thor
  def self.document(task)
    usage   = I18n.t("cli.#{namespace}.#{task}.command")
    summary = I18n.t("cli.#{namespace}.#{task}.summary")
    detail  = I18n.t("cli.#{namespace}.#{task}.detail")

    desc(usage, summary)
    long_desc(detail)
  end
end

class StatusChecker
  getter warn
  getter error

  def check(key)
    api = NewRelic::Api.new(key)

    parallel(
      accumulate_result(api.list_servers),
      accumulate_result(api.list_applications)
    )
  end

  private def accumulate_result(objects)
    objects.each do |object|
      case object.health_status
      when "gray", "green"
        next
      when "orange"
        @warn = true
      when "red"
        @error = true
      end
      puts "#{object.name}: #{object.health_status}"
    end
  end
end

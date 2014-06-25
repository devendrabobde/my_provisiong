namespace :pending_csv do
	desc 'Updates the pending unprocessed CSV files'
	task "update_pending_csvs" => :environment do
		audits = AuditTrail.where('createddate >=? AND upload_status=?', 2.days.ago, false)
		if audits.present?
			pending_audits = audits.select{|x| x if ((Time.now - x.createddate).to_i/(60*60) < 2)}
			pending_audits.each{|audit_trail| ProviderErrorLog.create( application_name: "OneStop Provisioning System", error_message: "Resque backgroud job failure", fk_audit_trail_id: audit_trail.id)} if pending_audits
			pending_audits.update_all(status: "1", upload_status: true) if pending_audits
			puts "#{pending_audits.count} CSV updated"
		end
	end
end
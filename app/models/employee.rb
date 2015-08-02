class Employee < ActiveRecord::Base
  
  validates :age, :department, :designation, :email_id, :location, :name,presence: true
  validates :email_id, uniqueness: {case_sensitive: false}
  validates_format_of :email_id, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  attr_accessible :age, :department, :designation, :email_id, :location, :name
  default_scope {where("is_deleted is not true")}
  def self.retrieve(params)
    if(params[:group_by].present?)
      attrs = ["name", "age", "email_id", "location", "department", "designation"]
      select_query = []
      attrs.each do |field|
        if(field == params[:group_by])
          select_query << params[:group_by]
        else
          select_query << "GROUP_CONCAT(" + field + ") " + field
        end
      end
      employees = Employee.select(select_query.join(","))
    end
    if(params[:search_term].present?)
      attrs = ["name", "age", "email_id", "location", "department", "designation"]
      select_query = []
      attrs.each do |field|
		select_query << field + " regexp '" + params[:search_term] + "'"
      end
      if(employees.present?)
		employees = employees.where(select_query.join(" or "))
      else
		employees = Employee.where(select_query.join(" or "))
      end
    end
    if(params[:group_by].present?)
		employees = employees.group(params[:group_by])
    end
    if(params[:sort_by].present? && params[:order].present?)
      if(employees.present?)
        employees = employees.order("#{params[:sort_by]} #{params[:order]}")
      else
        employees = Employee.order("#{params[:sort_by]} #{params[:order]}")
      end
    end
    if(employees.blank?)
      employees = Employee.all
    end
    employees
  end
end

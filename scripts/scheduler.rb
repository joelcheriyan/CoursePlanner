#Scheduler for courses

class Scheduler
	def initialize(course_list)
		@course_list = course_list
		@schedule_list = {}
		@cost = 0
	end
	
	def schedule()
	#Input: list of courses
	#	Format: {course_code1: {section1,section2,...},course_code2: [...],...]
	#			Section = sec_code: [ignore,ignore,ignore,[[rm1,[time1],[time2],...],[rm2,[time1],[time2]],...]]
	
	#Convert to correct input type
		formatted_course_list = {}
		@course_list.each do |course_code, section_list|
			formatted_course_list[course_code] = {}
			
		end
		optimal_schedule = schedule_all(@course_list)
		#Convert output to hash
		@cost = optimal_schedule['cost']
		@course_list.each_with_index do |course_array, course_index|
			key = course_array[0]
			section_codes = []
			course_array[1].each_with_index do |section_array, section_index|				
				section_codes += [section_array[optimal_schedule['schedule'][course_index][section_index]][0]]
			end
			@schedule_list[key] = section_codes
		end
		return @schedule_list
	end
	
	def schedule_all(course_list)
	#Return schedule and overlap of all courses with min overlap into @schedule_list and @cost
	#Input: list of courses
	#	Format: [[course_code1, [section_set1,section_set2,...]],[course_code2, [section_set1,section_set2,...]],...]
	#			Section_set = [[code,['T',13,14],['M',11,15]],etc.,[code,[['T',11,14],['M',11,13],etc.],...]
	#		input[n] = nth course
	#		input[n][0] = code of nth course
	#		input[n][1][k] = kth section set of nth course
	#		input[n][1][k][m] = mth option of kth section set of nth course
	#		input[n][1][k][m][0] = section code of mth option of kth section set of nth course
	#		input[n][1][k][m][1][x] = xth time elem of code of mth option of kth section set of nth course
		optimal_schedule = Array.new
		optimal_cost = Float::INFINITY
		current_schedule = Array.new(course_list.count)

		#max_options stores the number of possible choices for each section_set
		max_options = Array.new(course_list.count)
		course_list.each_with_index do |temp_array, index|
			current_schedule[index] = Array.new(temp_array[1].count,0)
			max_options[index] = Array.new(temp_array[1].count,0)
			temp_array[1].each_with_index do |temp_array2, index2|
				max_options[index][index2] = temp_array2.count
			end
		end

		current_index = [0,0]		

		while optimal_cost > 0 and current_index[0]<current_schedule.count
			#get current schedule and calculate overlap
			schedule_list = []
			course_list.each_with_index do |course_array, course_index|
				current_course = [course_array[0]]
				course_array[1].each_with_index do |section_array, section_index|				
					current_course += section_array[current_schedule[course_index][section_index]][1..-1]
				end
				schedule_list.push(current_course)
			end
						
			overlap = calculate_overlap(schedule_list)['Total']
			
			if overlap < optimal_cost
				optimal_cost = overlap
				optimal_schedule = Marshal.load(Marshal.dump(current_schedule))
			end
			
			#increment field
			current_index = [0,0]
			while current_index[0]<current_schedule.count and current_schedule[current_index[0]][current_index[1]] >= max_options[current_index[0]][current_index[1]]-1
				current_schedule[current_index[0]][current_index[1]] = 0
				if current_index[1] < current_schedule[current_index[0]].count - 1
					current_index[1] += 1
				else
					current_index[1] = 0
					current_index[0] += 1
				end
			end
						
			if current_index[0]<current_schedule.count
				current_schedule[current_index[0]][current_index[1]] += 1
			end
		end

		return {'cost' => optimal_cost, 'schedule' => optimal_schedule}
	end
	
	def calculate_overlap(course_list)
	#Input: list of courses
	#	Format: [[course_code,['M',15,18],['T',9,13],...],...]
	
		costs = {'Total' => 0}
		
		course_list.each_with_index do |main_array, index|
			costs[main_array[0]] = 0
			main_array[1..-1].each_with_index do |sub_array, sub_index|
				#Iterate again, counting all overlaps
				course_list.each_with_index do |main_array_comp, index_comp|
					main_array_comp[1..-1].each_with_index do |sub_array_comp, sub_index_comp|
						if index != index_comp or sub_index != sub_index_comp
							#Check for day overlap
							if sub_array[0] == sub_array_comp[0]
								#Multiply costs by 2 for now to deal with self-overlap within course (should only be counted once)
								cost = 2*([sub_array[2],sub_array_comp[2]].min - [sub_array[1],sub_array_comp[1]].max)								
								costs['Total'] += cost > 0 ? cost : 0
								if index == index_comp
									cost /= 2
								end
								costs[main_array[0]] += cost > 0 ? cost : 0
							end
						end
					end
				end
			end
			costs[main_array[0]] /= 2
		end	
		costs['Total'] /= 2
		return costs
	end
end
# # The Passport Problem

# Let's now apply what we have learnt to solve a real modelling problem.

# The [Passport Index Dataset](https://github.com/ilyankou/passport-index-dataset)
# lists travel visa requirements for 199 countries, in `.csv` format. Our task
# is to find out the minimum number of passports required to visit all
# countries without  requiring a visa.

# ## Data handling

# Read the following file into a dataframe:

const DATA_FILENAME = joinpath(@__DIR__, "data", "passport-index-matrix.csv")

passport_data = nothing  # Replace this with Code

# In this dataset, the first column represents a passport (=from) and each
# remaining column represents a foreign country (=to).

# The values in each cell are as follows:
# * 3 = visa-free travel
# * 2 = eTA is required
# * 1 = visa can be obtained on arrival
# * 0 = visa is required
# * -1 is for all instances where passport and destination are the same

# Extract the list of country names

countries = nothing  # Replace this with code

# Let's check that you found all 199 countries

@assert length(countries) == 199

# The values we are interested in are -1 and 3. Modify the dataframe so that
# the -1 and 3 are `1` (true), and all others are `0` (false).

nothing  # Replace this with code

# The values in the dataframe should now represent:
#  * 1 = no visa required for travel
#  * 0 = visa required for travel

# ## Visualization

# Produce a visualization of the passport data.  For example, you might want to
# plot a histogram of the number of countries that have visa-free travel.

nothing

# ## Modelling

# We can formulate the passport problem in math as follows:
# ```math
# \begin{aligned}
# \min && \sum_{i \in I} x_i \\
# \text{s.t.} && \sum_{i \in I} a_{i,j} \cdot x_i \geq 1 && \forall j \in I \\
# && x_i \in \{0,1\} && \forall i \in I
# \end{aligned}
# ```
# where $x_i$ is a binary variable indicating if we want to select passport $i$,
# and $a_{i,j}$ is 1 if there is visa-free travel between countries $i$ and $j$,
# and 0 otherwise.

# Formulate and solve this problem with JuMP.

nothing

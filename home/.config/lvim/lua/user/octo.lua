local M = {}

local icons = require("user.icons").icons

M.edit_wrapper = function(cmd)
    local number = vim.fn.input "Number: "
    vim.cmd(cmd .. " " .. number)
end

M.merge_wrapper = function()
    local method = vim.fn.input "Method [commit|rebase|squash|delete]: "
    vim.cmd("Octo pr merge " .. method)
end

M.label_wrapper = function(cmd)
    local label = vim.fn.input "Label: "
    vim.cmd(cmd .. " " .. label)
end

M.assignee_wrapper = function(cmd)
    local label = vim.fn.input "Login: "
    vim.cmd(cmd .. " " .. label)
end

M.config = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then
        return
    end
    require("octo").setup()

    wk.register {
        -- Lsp
        ["<space>"] = {
            name = icons.codelens .. "Octo",
            -- Issues submenu
            s = {
                "<cmd>Octo search<cr>",
                icons.find .. " Live search",
            },
            i = {
                name = icons.error .. "Issues",
                l = {
                    "<cmd>Octo issue list<cr>",
                    "List issues",
                },
                c = {
                    "<cmd>Octo issue close<cr>",
                    "Close this issue",
                },
                C = {
                    "<cmd>Octo issue create<cr>",
                    "Create a new issue",
                },
                e = {
                    "<cmd>lua require('user.octo').edit_wrapper('Octo issue edit')<cr>",
                    "Edit an issue",
                },
                s = {
                    "<cmd>Octo issue search<cr>",
                    "Search in all issues",
                },
                o = {
                    "<cmd>Octo issue browser<cr>",
                    "Open issue in browser",
                },
                r = {
                    "<cmd>Octo issue reload<cr>",
                    "Reload issue",
                },
                R = {
                    "<cmd>Octo issue reopen<cr>",
                    "Re-open issue",
                },
                u = {
                    "<cmd>Octo issue url<cr>",
                    "Copy issue URL",
                },
            },
            p = {
                name = icons.ls_active .. "Pull requests",
                l = {
                    "<cmd>Octo pr list<cr>",
                    "List pull requests",
                },
                c = {
                    "<cmd>Octo pr close<cr>",
                    "Close this pull request",
                },
                C = {
                    "<cmd>Octo pr create<cr>",
                    "Create a new pull request",
                },
                e = {
                    "<cmd>lua require('user.octo').edit_wrapper('Octo pr edit')<cr>",
                    "Edit a pull request",
                },
                s = {
                    "<cmd>Octo pr search<cr>",
                    "Search in all pull requests",
                },
                o = {
                    "<cmd>Octo pr browser<cr>",
                    "Open pull request in browser",
                },
                r = {
                    "<cmd>Octo pr reload<cr>",
                    "Reload pull request",
                },
                R = {
                    "<cmd>Octo pr reopen<cr>",
                    "Re-open pull request",
                },
                u = {
                    "<cmd>Octo pr url<cr>",
                    "Copy pull request URL",
                },
                d = {
                    "<cmd>Octo pr diff<cr>",
                    "Open pull request diff",
                },
                g = {
                    "<cmd>Octo pr diff<cr>",
                    "List pull request commits",
                },
                G = {
                    "<cmd>Octo pr changes<cr>",
                    "List pull request changes",
                },
                m = {
                    "<cmd>lua require('user.octo').merge_wrapper()<cr>",
                    "Merge pull request",
                },
            },
            r = {
                name = icons.folder .. " Repositories",
                l = {
                    "<cmd>Octo repo list<cr>",
                    "List repositories",
                },
                f = {
                    "<cmd>Octo repo fork<cr>",
                    "Fork repository",
                },
                b = {
                    "<cmd>Octo repo browser<cr>",
                    "Open repository in browser",
                },
                u = {
                    "<cmd>Octo repo url<cr>",
                    "Copy repository URL",
                },
            },
            c = {
                name = icons.comment .. " Comments",
                a = {
                    "<cmd>Octo comment add<cr>",
                    "Add comment",
                },
                d = {
                    "<cmd>Octo comment delete<cr>",
                    "Delete comment",
                },
            },
            t = {
                name = icons.screen .. "Thread",
                r = {
                    "<cmd>Octo thread resolve<cr>",
                    "Resolve thread",
                },
                R = {
                    "<cmd>Octo thread unresolve<cr>",
                    "Unesolve thread",
                },
            },
            l = {
                name = icons.label .. "Labels",
                a = {
                    "<cmd>lua require('user.octo').label_wrapper('Octo label add')<cr>",
                    "Add a label",
                },
                r = {
                    "<cmd>lua require('user.octo').label_wrapper('Octo label remove')<cr>",
                    "Remove a label",
                },
                c = {
                    "<cmd>lua require('user.octo').label_wrapper('Octo label create')<cr>",
                    "Create a new label",
                },
            },
            a = {
                name = icons.person .. " Reviewers",
                a = {
                    "<cmd>lua require('user.octo').assignee_wrapper('Octo assignees add')<cr>",
                    "Add an assignee",
                },
                A = {
                    "<cmd>lua require('user.octo').assignee_wrapper('Octo assignees remove')<cr>",
                    "Add an assignee",
                },
                r = {
                    "<cmd>lua require('user.octo').assignee_wrapper('Octo reviewer add')<cr>",
                    "Add a reviewer",
                },
            },
            e = {
                name = icons.magic .. "Reactions",
                u = {
                    "<cmd>Octo reaction thumbs_up<cr>",
                    "Add +1 reaction",
                },
                d = {
                    "<cmd>Octo reaction thumbs_down<cr>",
                    "Add -1 reaction",
                },
                l = {
                    "<cmd>Octo reaction laugh<cr>",
                    "Add laugh reaction",
                },
                c = {
                    "<cmd>Octo reaction confused<cr>",
                    "Add confused reaction",
                },
                r = {
                    "<cmd>Octo reaction rocket<cr>",
                    "Add rocket reaction",
                },
                h = {
                    "<cmd>Octo reaction heart<cr>",
                    "Add heart reaction",
                },
                t = {
                    "<cmd>Octo reaction tada<cr>",
                    "Add party reaction",
                },
            },
            R = {
                name = icons.settings .. "Review",
                s = {
                    "<cmd>Octo review start<cr>",
                    "Start a review",
                },
                S = {
                    "<cmd>Octo review submit<cr>",
                    "Submit a review",
                },
                r = {
                    "<cmd>Octo review resume<cr>",
                    "Resume a review",
                },
                d = {
                    "<cmd>Octo review discard<cr>",
                    "Discard a review",
                },
                c = {
                    "<cmd>Octo review comments<cr>",
                    "View all pending comments",
                },
                C = {
                    "<cmd>Octo review commit<cr>",
                    "Pick a specific commit to review",
                },
            },
        },
    }
end

return M
